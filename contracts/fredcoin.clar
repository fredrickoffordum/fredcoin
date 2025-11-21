;; title: fredcoin
;; version: 1.0.0
;; summary: A simple fungible token called fredcoin
;; description: Minimal fungible token implementation with minting controlled by the contract deployer.

(define-fungible-token fredcoin)

;; constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-BALANCE (err u101))

;; data vars
(define-data-var token-admin principal tx-sender)

;; read-only functions
(define-read-only (get-admin)
  (ok (var-get token-admin)))

(define-read-only (get-balance (owner principal))
  (ok (ft-get-balance fredcoin owner)))

(define-read-only (get-total-supply)
  (ok (ft-get-supply fredcoin)))

;; public functions
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get token-admin)) ERR-NOT-AUTHORIZED)
    (var-set token-admin new-admin)
    (ok true)))

(define-public (mint (recipient principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender (var-get token-admin)) ERR-NOT-AUTHORIZED)
    (ft-mint? fredcoin amount recipient)))

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts!
      (>= (ft-get-balance fredcoin sender) amount)
      ERR-INSUFFICIENT-BALANCE)
    (ft-transfer? fredcoin amount sender recipient)))

;; private functions
