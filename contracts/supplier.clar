;; Supplier contract for storing supplier information

;; Define the supplier data structure
(define-data-var supplier-id-nonce uint u0)

;; Map to store supplier information
(define-map suppliers
  uint
  {
    name: (string-ascii 256),
    location: (string-ascii 256),
    verification-status: bool,
    ipfs-hashes: (list 10 (string-ascii 64))
  }
)

;; Trait for supplier operations
(define-trait supplier-trait
  (
    (register-supplier (principal (string-ascii 256) (string-ascii 256)) (response uint uint))
    (update-supplier (uint (string-ascii 256) (string-ascii 256) bool) (response bool uint))
    (verify-supplier (uint) (response bool uint))
    (get-supplier (uint) (response 
      {
        name: (string-ascii 256),
        location: (string-ascii 256),
        verification-status: bool,
        ipfs-hashes: (list 10 (string-ascii 64))
      } 
      uint))
  )
)

;; Implement the supplier trait
(define-public (register-supplier (supplier-principal principal) (name (string-ascii 256)) (location (string-ascii 256)))
  (let
    (
      (new-id (var-get supplier-id-nonce))
    )
    (begin
      (var-set supplier-id-nonce (+ new-id u1))
      (map-set suppliers new-id
        {
          name: name,
          location: location,
          verification-status: false,
          ipfs-hashes: (list)
        }
      )
      (ok new-id)
    )
  )
)

(define-public (update-supplier (supplier-id uint) (name (string-ascii 256)) (location (string-ascii 256)) (verification-status bool))
  (let
    (
      (supplier (unwrap! (map-get? suppliers supplier-id) (err u1)))
    )
    (begin
      (map-set suppliers supplier-id
        {
          name: name,
          location: location,
          verification-status: verification-status,
          ipfs-hashes: (get ipfs-hashes supplier)
        }
      )
      (ok true)
    )
  )
)

(define-public (verify-supplier (supplier-id uint))
  (let
    (
      (supplier (unwrap! (map-get? suppliers supplier-id) (err u1)))
    )
    (begin
      (map-set suppliers supplier-id
        (merge supplier { verification-status: true })
      )
      (ok true)
    )
  )
)