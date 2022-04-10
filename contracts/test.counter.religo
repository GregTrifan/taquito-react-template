#include "counter.religo"

let assert_string_failure = ((res,expected) : (test_exec_result, string)) : unit => {
  let expected = Test.eval (expected) ;
  switch (res) {
  | Fail (Rejected (actual,_)) => assert (Test.michelson_equal (actual, expected))
  | Fail (Other) => failwith ("contract failed for an unknown reason")
  | Success (_) => failwith ("bad value check")
  }
};
//TODO: Check if the test actually works
let test = 
    let (counter_ta,_code,_size) = Test.originate (main, 10,0tez);

    let counter_ctr = Test.to_contract(counter_ta);

    let ok_case : test_exec_result = Test.transfer_to_contract(counter_ctr,13,0tez);
    let _u = switch (ok_case) {
    | Success (_) =>
      let storage = Test.get_storage (pedro_taco_shop_ta) ;
      assert (eq_in_map(23, storage))
    | Fail (x) => failwith ("ok test case failed")
  } ;