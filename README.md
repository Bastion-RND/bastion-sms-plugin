# bastion-sms

basic sms send/delivery plugin

## Install

```bash
npm install bastion-sms
npx cap sync
```

## API

<docgen-index>

* [Type Aliases](#type-aliases)
* [Enums](#enums)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

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
