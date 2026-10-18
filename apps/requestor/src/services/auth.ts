/**
 * Auth store for Requestor App using Zustand-like pattern
 * (plain React state module — zero-dependency for MVP).
 */
import { post, setToken, clearToken } from '@swachta/shared';

export interface AuthState {
  isAuthenticated: boolean;
  phone: string;
  otpSent: boolean;
  token: string | null;
  household: any | null;
  loading: boolean;
  error: string | null;
}

const initialState: AuthState = {
  isAuthenticated: false,
  phone: '',
  otpSent: false,
  token: null,
  household: null,
  loading: false,
  error: null,
};

/**
 * Request OTP for a phone number.
 * In mock mode the backend logs the OTP to console.
 */
export async function requestOtp(phone: string): Promise<{ success: boolean; error?: string }> {
  try {
    await post('/auth/otp/request', { phone }, { skipAuth: true });
    return { success: true };
  } catch (err: any) {
    return { success: false, error: err.detail || err.message };
  }
}

/**
 * Verify OTP and receive a JWT token.
 */
export async function verifyOtp(
  phone: string,
  otp: string
): Promise<{ success: boolean; token?: string; household?: any; error?: string }> {
  try {
    const result = await post<{ access_token: string; household: any }>(
      '/auth/otp/verify',
      { phone, otp },
      { skipAuth: true }
    );
    await setToken(result.access_token);
    return { success: true, token: result.access_token, household: result.household };
  } catch (err: any) {
    return { success: false, error: err.detail || err.message };
  }
}

/**
 * Complete household onboarding profile.
 */
export async function completeOnboarding(data: {
  address_line: string;
  ward_id: number;
  household_size_band: string;
  schedule_preference: string;
}): Promise<{ success: boolean; household?: any; error?: string }> {
  try {
    const result = await post<any>('/households/me/onboard', data);
    return { success: true, household: result };
  } catch (err: any) {
    return { success: false, error: err.detail || err.message };
  }
}

export async function logout(): Promise<void> {
  await clearToken();
}
