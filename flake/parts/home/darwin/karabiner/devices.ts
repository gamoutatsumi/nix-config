import * as k from "karabiner_ts";

export const INTERNAL = {
  product_id: 834,
  vendor_id: 1452,
} as const satisfies k.DeviceIdentifier;

export const isAppleInternalKeyboard = k.ifDevice([INTERNAL]).unless();
