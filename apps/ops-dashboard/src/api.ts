/**
 * API client for Ops Dashboard (browser fetch).
 */
const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000/api/v1';

function getToken(): string | null {
  return localStorage.getItem('swachta_ops_token');
}

export function setToken(token: string): void {
  localStorage.setItem('swachta_ops_token', token);
}

export function clearToken(): void {
  localStorage.removeItem('swachta_ops_token');
}

export class ApiError extends Error {
  status: number;
  detail: string;
  constructor(status: number, detail: string) {
    super(`API ${status}: ${detail}`);
    this.status = status;
    this.detail = detail;
  }
}

interface FetchOptions {
  method?: string;
  body?: Record<string, unknown>;
  skipAuth?: boolean;
}

async function apiFetch<T = unknown>(path: string, opts: FetchOptions = {}): Promise<T> {
  const { method = 'GET', body, skipAuth = false } = opts;
  const headers: Record<string, string> = {};

  if (!skipAuth) {
    const token = getToken();
    if (token) headers['Authorization'] = `Bearer ${token}`;
  }

  let fetchBody: string | undefined;
  if (body) {
    headers['Content-Type'] = 'application/json';
    fetchBody = JSON.stringify(body);
  }

  const res = await fetch(`${BASE_URL}${path}`, { method, headers, body: fetchBody });

  if (!res.ok) {
    let detail = `HTTP ${res.status}`;
    try {
      const err = await res.json();
      detail = err.detail || err.message || detail;
    } catch { /* ignore */ }
    throw new ApiError(res.status, detail);
  }

  if (res.status === 204) return undefined as T;
  return (await res.json()) as T;
}

// ── Ops-specific API calls ──────────────────────────────────────────────────

export async function opsLogin(email: string, password: string) {
  const result = await apiFetch<{ access_token: string; user: any }>(
    '/auth/ops/login',
    { method: 'POST', body: { email, password }, skipAuth: true }
  );
  setToken(result.access_token);
  return result;
}

export async function fetchMetrics() {
  return apiFetch<any>('/ops/metrics');
}

export async function fetchHouseholds(params?: { ward_id?: number; search?: string }) {
  const query = new URLSearchParams();
  if (params?.ward_id) query.set('ward_id', String(params.ward_id));
  if (params?.search) query.set('search', params.search);
  const qs = query.toString();
  return apiFetch<any[]>(`/ops/households${qs ? '?' + qs : ''}`);
}

export async function fetchWorkers() {
  return apiFetch<any[]>('/ops/workers');
}

export async function fetchIssues(status?: string) {
  const qs = status ? `?status=${status}` : '';
  return apiFetch<any[]>(`/ops/issues${qs}`);
}

export async function updateIssue(issueId: string, data: { status: string; resolution_notes?: string }) {
  return apiFetch<any>(`/ops/issues/${issueId}`, { method: 'PATCH', body: data });
}

export async function fetchLiveTicketsMap(ward_id?: number) {
  const qs = ward_id ? `?ward_id=${ward_id}` : '';
  return apiFetch<any[]>(`/ops/tickets/live-map${qs}`);
}

export async function assignTicket(issueId: string, data: { worker_id: string; waste_category?: string; estimated_volume_m3?: number }) {
  return apiFetch<any>(`/ops/tickets/${issueId}/assign`, { method: 'POST', body: data });
}

export async function fetchSlaMetrics(ward_id?: number) {
  const qs = ward_id ? `?ward_id=${ward_id}` : '';
  return apiFetch<any>(`/ops/sla-metrics${qs}`);
}

export async function fetchRecyclablesSummary(ward_id?: number) {
  const qs = ward_id ? `?ward_id=${ward_id}` : '';
  return apiFetch<any>(`/ops/recyclables/summary${qs}`);
}

export async function recordRecyclableSale(data: {
  ward_id: number;
  material: string;
  weight_kg: number;
  procured_rate_per_kg: number;
  resale_rate_per_kg: number;
  buyer_name: string;
  buyer_contact?: string;
  notes?: string;
}) {
  return apiFetch<any>('/ops/recyclables/record-sale', { method: 'POST', body: data });
}

export async function logHubIntake(data: { ward_id: number; stream: string; weight_kg: number; notes?: string }) {
  return apiFetch<any>('/ops/hub-intake', { method: 'POST', body: data });
}
