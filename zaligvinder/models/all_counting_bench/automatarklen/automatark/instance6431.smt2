(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]{2})(00[1-9]|0[1-9][0-9]|[1-2][0-9][0-9]|3[0-5][0-9]|36[0-6])$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.++ (str.to_re "00") (re.range "1" "9")) (re.++ (str.to_re "0") (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "5") (re.range "0" "9")) (re.++ (str.to_re "36") (re.range "0" "6"))) (str.to_re "\u{0a}"))))
; ^1+0+$
(assert (str.in_re X (re.++ (re.+ (str.to_re "1")) (re.+ (str.to_re "0")) (str.to_re "\u{0a}"))))
; [1-8][0-9]{2}[0-9]{5}
(assert (str.in_re X (re.++ (re.range "1" "8") ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; YWRtaW46YWRtaW4www\x2Ee-finder\x2EccNSIS_DOWNLOADHost\x3A
(assert (not (str.in_re X (str.to_re "YWRtaW46YWRtaW4www.e-finder.ccNSIS_DOWNLOADHost:\u{0a}"))))
; /filename=[^\n]*\u{2e}rp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rp/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
