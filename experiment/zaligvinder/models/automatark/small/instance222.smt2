(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{8}$
(assert (not (str.in_re X (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^([0-9]*\,?[0-9]+|[0-9]+\,?[0-9]*)?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ",")) (re.+ (re.range "0" "9"))) (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re ",")) (re.* (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; User-Agent\x3A\x2FrssMinutesansweras\x2Estarware\x2EcomFictionalHost\x3AHost\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:/rssMinutesansweras.starware.comFictionalHost:Host:\u{0a}"))))
(check-sat)
