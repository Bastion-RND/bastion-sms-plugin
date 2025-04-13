# bastion-sms-plugin

Basic SMS Android/IOS plugin for Capacitor 6 and higher

## Install

```bash
npm i @bs-solutions/bastion-sms-plugin
npx cap sync
```

## API

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

```ts
const { deliveryStatus } = await BastionSMSPlugin.sendSMS({ phoneNumber, message });
```

### Type Aliases

#### TSmsSendPayload


<code>{ phoneNumber: string; message: string; }</code>


#### TSmsSendResponse

<code>{ sentStatus: <a href="#sentstatus">SentStatus</a>; deliveryStatus: <a href="#deliverystatus">DeliveryStatus</a>; }</code>


### Enums


#### SentStatus

| Members      | Value                 |
| ------------ | --------------------- |
| **`SENT`**   | <code>'SENT'</code>   |
| **`FAILED`** | <code>'FAILED'</code> |


#### DeliveryStatus

| Members         | Value                    |
| --------------- | ------------------------ |
| **`DELIVERED`** | <code>'DELIVERED'</code> |
| **`FAILED`**    | <code>'FAILED'</code>    |

</docgen-api>

## Maintainer

[sudondie](https://github.com/sudondie)

## Contributing

Please contribute! [Look at the issues](https://github.com/Bastion-RND/bastion-sms-plugin/issues).

## License

MIT © 2025