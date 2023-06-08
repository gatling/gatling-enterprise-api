namespace io.gatling.enteprise

use alloy#simpleRestJson
use smithy.api#httpLabel

@simpleRestJson
service HelloService {
  version: "0.0.0"
  operations: [HelloOperation]
}

@http(method: "POST", uri: "/hello/{name}", code: 200)
operation HelloOperation {
  input: HelloInput
  output: HelloOutput
}


structure HelloInput {
  @required
  @httpLabel
  name: String,
}

structure HelloOutput {
  @required
  value: String
}
