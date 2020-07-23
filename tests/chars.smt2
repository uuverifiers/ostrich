(set-logic QF_)

(declare-fun x () String)
(declare-fun z () String)
(declare-fun a () String)
(declare-fun b () String)
(declare-fun c () String)

; (declare-fun ch () Int)

(assert (= (str.from_code 90) x))
; (assert (= (str.from_code ch) x))
(assert (= (str.from_code (- 1)) z))
(assert (= (str.from_code (bv2nat #x73)) a))
(assert (= (seq.unit #x73) b))
(assert (= (str.++ (seq.unit #b01110011) (seq.unit #b01110100) (seq.unit #b01110010) (seq.unit #b01101001) (seq.unit #b01101110) (seq.unit #b01100111)) c))

(check-sat)
