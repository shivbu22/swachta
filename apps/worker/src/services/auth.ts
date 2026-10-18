/**
 * Auth service module for Worker App — PIN login and token management.
 */
import { post, setToken, clearToken } from '@swachta/shared';

/**
 * Worker login with phone + PIN.
 */
export async function loginWithPin(
  phone: string,
  pin: string
): Promise<{ success: boolean; token?: string; worker?: any; error?: string }> {
  try {
    const result = await post<{ access_token: string; worker: any }>(
      '/auth/worker/login',
      { phone, pin },
      { skipAuth: true }
    );
    await setToken(result.access_token);
    return { success: true, token: result.access_token, worker: result.worker };
  } catch (err: any) {
    return { success: false, error: err.detail || err.message };
  }
}

export async function logout(): Promise<void> {
  await clearToken();
}
