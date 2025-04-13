import { registerPlugin } from '@capacitor/core';

import type { IBastionSMSPlugin } from './definitions';

export const BastionSMSPlugin = registerPlugin<IBastionSMSPlugin>('BastionSMSPlugin');

export * from './definitions';