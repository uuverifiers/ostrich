;---
; using 7-bit bit-vectors as characters
; check membership of .Net regex
; regexA = /([^\x00-\xFF]\s*)/u
;---
(set-info :status unsat)
(set-option :print-success true)
(set-logic QF_BVS)
(define-sort CHAR () (_ BitVec 7))
(declare-const regexA (RegEx CHAR))
(declare-const x (Seq CHAR))

(assert (= regexA (re-concat (re-range #b0101111 #b0101111)(re-concat (re-concat (as re-empty-set (RegEx CHAR)) (re-star (re-union (re-range #b0001001 #b0001101) (re-range #b0100000 #b0100000)))) (re-of-seq (seq-cons #b0101111 (seq-cons #b1110101 (as seq-empty (Seq CHAR)))))))))

;check that the regex contains some x
(assert (re-member x regexA))
(check-sat)
