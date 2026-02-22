;; Test for counter.clar
(define-test increment-test
  (asserts! (is-eq (unwrap-panic (contract-call? .counter increment)) u1) (err u1))
  (asserts! (is-eq (contract-call? .counter get-counter) u1) (err u1))
)