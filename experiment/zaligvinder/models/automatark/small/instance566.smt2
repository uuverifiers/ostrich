(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AHost\x3Aalertseqepagqfphv\u{2f}sfd
(assert (not (str.in_re X (str.to_re "Host:Host:alertseqepagqfphv/sfd\u{0a}"))))
; Download\d+ocllceclbhs\u{2f}gth
(assert (not (str.in_re X (re.++ (str.to_re "Download") (re.+ (re.range "0" "9")) (str.to_re "ocllceclbhs/gth\u{0a}")))))
; ^([a-hA-H]{1}[1-8]{1})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (re.range "a" "h") (re.range "A" "H"))) ((_ re.loop 1 1) (re.range "1" "8"))))))
; Host\x3Astech\x2Eweb-nexus\x2EnetHost\x3A
(assert (str.in_re X (str.to_re "Host:stech.web-nexus.netHost:\u{0a}")))
(check-sat)
