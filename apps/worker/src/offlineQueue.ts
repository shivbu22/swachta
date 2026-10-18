/**
 * Offline-first Queue Manager for Swachta Worker App
 * Caches collection stops and photo proofs when network is unavailable in Ghaziabad alleys.
 * Automatically synchronizes with FastAPI backend upon network reconnection.
 */

export interface QueuedVerification {
  id: string;
  stopId: string;
  stream: 'wet' | 'dry' | 'reject';
  quality: 'clean' | 'partial' | 'none';
  weightKg: number;
  photoUrl: string;
  latitude: number;
  longitude: number;
  timestamp: string;
  synced: boolean;
}

export interface QueuedHotspotResolution {
  id: string;
  ticketId: string;
  resolvedPhotoUrl: string;
  latitude: number;
  longitude: number;
  notes: string;
  timestamp: string;
  synced: boolean;
}

class OfflineQueueManager {
  private verificationsQueue: QueuedVerification[] = [];
  private hotspotQueue: QueuedHotspotResolution[] = [];

  // Enqueue Stop Verification
  public enqueueVerification(verification: Omit<QueuedVerification, 'id' | 'synced' | 'timestamp'>) {
    const item: QueuedVerification = {
      ...verification,
      id: 'queue_' + Date.now() + '_' + Math.random().toString(36).substr(2, 4),
      timestamp: new Date().toISOString(),
      synced: false
    };
    this.verificationsQueue.push(item);
    return item;
  }

  // Enqueue Hotspot Resolution
  public enqueueHotspotResolution(resolution: Omit<QueuedHotspotResolution, 'id' | 'synced' | 'timestamp'>) {
    const item: QueuedHotspotResolution = {
      ...resolution,
      id: 'hotspot_res_' + Date.now(),
      timestamp: new Date().toISOString(),
      synced: false
    };
    this.hotspotQueue.push(item);
    return item;
  }

  public getPendingCount(): number {
    return (
      this.verificationsQueue.filter(v => !v.synced).length +
      this.hotspotQueue.filter(h => !h.synced).length
    );
  }

  // Sync with Backend
  public async syncAll(apiBaseUrl: string, token: string): Promise<{ syncedVerifications: number; syncedHotspots: number }> {
    let syncedVerifications = 0;
    let syncedHotspots = 0;

    // Sync verifications
    for (const item of this.verificationsQueue) {
      if (!item.synced) {
        try {
          const res = await fetch(`${apiBaseUrl}/api/v1/verification/stops/${item.stopId}/verify`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify({
              stream: item.stream,
              quality: item.quality,
              weight_kg: item.weightKg,
              photo_url: item.photoUrl,
              collector_latitude: item.latitude,
              collector_longitude: item.longitude
            })
          });
          if (res.ok) {
            item.synced = true;
            syncedVerifications++;
          }
        } catch {
          // Network still down; remains queued
        }
      }
    }

    // Sync hotspot resolutions
    for (const item of this.hotspotQueue) {
      if (!item.synced) {
        try {
          const res = await fetch(`${apiBaseUrl}/api/v1/verification/tickets/${item.ticketId}/resolve`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify({
              resolved_photo_url: item.resolvedPhotoUrl,
              collector_latitude: item.latitude,
              collector_longitude: item.longitude,
              notes: item.notes
            })
          });
          if (res.ok) {
            item.synced = true;
            syncedHotspots++;
          }
        } catch {
          // Network still down; remains queued
        }
      }
    }

    return { syncedVerifications, syncedHotspots };
  }
}

export const offlineQueue = new OfflineQueueManager();
