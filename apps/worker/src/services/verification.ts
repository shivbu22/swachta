/**
 * Verification service for Worker App — create records and bulk sync offline queue.
 */
import { post, get } from '@swachta/shared';

export interface VerificationPayload {
  stop_id: string;
  stream: 'wet' | 'dry' | 'reject';
  photo_url: string;
  weight_kg: number;
  segregation_quality: 'clean' | 'partial' | 'none';
  client_id: string;
}

/**
 * Submit a single verification record.
 */
export async function submitVerification(
  payload: VerificationPayload
): Promise<{ success: boolean; id?: string; error?: string }> {
  try {
    const result = await post<{ id: string }>('/verification', payload);
    return { success: true, id: result.id };
  } catch (err: any) {
    return { success: false, error: err.detail || err.message };
  }
}

/**
 * Bulk sync offline queue.
 * The backend uses client_id for idempotency so replaying is safe.
 */
export async function bulkSync(
  records: VerificationPayload[]
): Promise<{ success: boolean; synced: number; error?: string }> {
  try {
    const result = await post<{ synced: number }>('/verification/bulk-sync', { records });
    return { success: true, synced: result.synced };
  } catch (err: any) {
    return { success: false, synced: 0, error: err.detail || err.message };
  }
}

/**
 * Fetch today's route for the authenticated worker.
 */
export async function fetchTodayRoute(): Promise<{ success: boolean; route?: any; error?: string }> {
  try {
    const route = await get<any>('/routes/today');
    return { success: true, route };
  } catch (err: any) {
    return { success: false, error: err.detail || err.message };
  }
}

/**
 * Mark a stop as arrived.
 */
export async function markArrived(stopId: string): Promise<{ success: boolean; error?: string }> {
  try {
    await post(`/routes/stops/${stopId}/arrive`);
    return { success: true };
  } catch (err: any) {
    return { success: false, error: err.detail || err.message };
  }
}

/**
 * Mark a stop as missed.
 */
export async function markMissed(
  stopId: string,
  reason: 'not_home' | 'gate_locked' | 'refused' | 'other'
): Promise<{ success: boolean; error?: string }> {
  try {
    await post(`/routes/stops/${stopId}/miss`, { reason });
    return { success: true };
  } catch (err: any) {
    return { success: false, error: err.detail || err.message };
  }
}
