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