;; Sustainability Passport NFT Contract

;; SIP-009 NFT Trait
(define-trait sip009-nft-trait
  (
    (get-last-token-id () (response uint uint))
    (get-token-uri (uint) (response (optional (string-ascii 256)) uint))
    (get-owner (uint) (response (optional principal) uint))
    (transfer (uint principal principal) (response bool uint))
  )
)

;; NFT Data Structure
(define-non-fungible-token sustainability-passport uint)

;; Passport data map
(define-map passport-data
  uint
  {
    product-name: (string-ascii 256),
    supplier-id: uint,
    sustainability-score: uint,
    carbon-footprint: uint,
    materials: (list 10 (string-ascii 64)),
    certifications: (list 10 (string-ascii 64)),
    ipfs-hash: (string-ascii 64),
    mint-date: uint
  }
)

;; Data variables
(define-data-var last-token-id uint u0)
(define-data-var base-uri (string-ascii 256) "https://api.example.com/passports/")

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-TOKEN-NOT-FOUND (err u101))
(define-constant ERR-INVALID-SCORE (err u102))

;; SIP-009 Implementation
(define-read-only (get-last-token-id)
  (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
  (let
    (
      (base (var-get base-uri))
    )
    (ok (some (concat base (uint-to-ascii token-id))))
  )
)

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? sustainability-passport token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) ERR-NOT-AUTHORIZED)
    (nft-transfer? sustainability-passport token-id sender recipient)
  )
)

;; Mint function
(define-public (mint (recipient principal) (product-name (string-ascii 256)) (supplier-id uint) (sustainability-score uint) (carbon-footprint uint) (materials (list 10 (string-ascii 64))) (certifications (list 10 (string-ascii 64))) (ipfs-hash (string-ascii 64)))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (begin
      (asserts! (<= sustainability-score u100) ERR-INVALID-SCORE)
      (try! (nft-mint? sustainability-passport token-id recipient))
      (map-set passport-data token-id
        {
          product-name: product-name,
          supplier-id: supplier-id,
          sustainability-score: sustainability-score,
          carbon-footprint: carbon-footprint,
          materials: materials,
          certifications: certifications,
          ipfs-hash: ipfs-hash,
          mint-date: block-height
        }
      )
      (var-set last-token-id token-id)
      (ok token-id)
    )
  )
)

;; Read-only function to get passport data
(define-read-only (get-passport-data (token-id uint))
  (map-get? passport-data token-id)
)

;; Function to update passport data (only by owner)
(define-public (update-passport-data (token-id uint) (sustainability-score uint) (carbon-footprint uint) (certifications (list 10 (string-ascii 64))))
  (let
    (
      (owner (unwrap! (nft-get-owner? sustainability-passport token-id) ERR-TOKEN-NOT-FOUND))
      (current-data (unwrap! (map-get? passport-data token-id) ERR-TOKEN-NOT-FOUND))
    )
    (begin
      (asserts! (is-eq tx-sender owner) ERR-NOT-AUTHORIZED)
      (asserts! (<= sustainability-score u100) ERR-INVALID-SCORE)
      (map-set passport-data token-id
        (merge current-data {
          sustainability-score: sustainability-score,
          carbon-footprint: carbon-footprint,
          certifications: certifications
        })
      )
      (ok true)
    )
  )
)