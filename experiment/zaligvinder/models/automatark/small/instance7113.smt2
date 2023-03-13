(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\w+page=largePass-Onseqepagqfphv\u{2f}sfd
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "page=largePass-Onseqepagqfphv/sfd\u{0a}")))))
; ^[SFTG]\d{7}[A-Z]$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "S") (str.to_re "F") (str.to_re "T") (str.to_re "G")) ((_ re.loop 7 7) (re.range "0" "9")) (re.range "A" "Z") (str.to_re "\u{0a}")))))
(check-sat)
