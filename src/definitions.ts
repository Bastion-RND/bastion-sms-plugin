export enum SentStatus {
  SENT = 'SENT',
  FAILED = 'FAILED',
}

export enum DeliveryStatus {
  DELIVERED = 'DELIVERED',
  FAILED = 'FAILED',
}

type TSmsSendPayload = {
  phoneNumber: string;
  message: string;
};

type TSmsSendResponse = {
  sentStatus: SentStatus;
  deliveryStatus: DeliveryStatus;
};

export interface IBastionSMSPlugin {
  sendSMS: ({ phoneNumber, message }: TSmsSendPayload) => Promise<TSmsSendResponse>;
}
