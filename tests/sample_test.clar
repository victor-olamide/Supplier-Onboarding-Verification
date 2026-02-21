;; Sample test for sample.clar
(define-test say-hi-test
  (asserts! (is-eq (unwrap-panic (contract-call? .sample say-hi)) "Hello World") (err u1))
)