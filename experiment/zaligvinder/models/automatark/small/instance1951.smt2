(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; YWRtaW46YWRtaW4www\x2Ee-finder\x2EccNSIS_DOWNLOADHost\x3A
(assert (str.in_re X (str.to_re "YWRtaW46YWRtaW4www.e-finder.ccNSIS_DOWNLOADHost:\u{0a}")))
; /\/stat_u\/$/U
(assert (str.in_re X (str.to_re "//stat_u//U\u{0a}")))
; ^[\d]{1,}?\.[\d]{2}$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
