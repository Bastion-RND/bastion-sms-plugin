export enum SentStatus {
  SENT = 'SENT',
  FAILED = 'FAILED',
}

export enum DeliveryStatus {
  DELIVERED = 'DELIVERED',
  FAILED = 'FAILED',
}

export type TSmsSendPayload = {
  phoneNumber: string;
  message: string;
};

export type TSmsSendResponse = {
  sentStatus: SentStatus;
  deliveryStatus: DeliveryStatus;
};

export interface IBastionSMSPlugin {
  sendSMS: ({ phoneNumber, message }: TSmsSendPayload) => Promise<TSmsSendResponse>;
}
