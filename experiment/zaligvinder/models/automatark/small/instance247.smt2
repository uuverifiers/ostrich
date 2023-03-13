(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-hA-H]{1}[1-8]{1})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (re.range "a" "h") (re.range "A" "H"))) ((_ re.loop 1 1) (re.range "1" "8"))))))
; Host\x3AHost\x3Aalertseqepagqfphv\u{2f}sfd
(assert (not (str.in_re X (str.to_re "Host:Host:alertseqepagqfphv/sfd\u{0a}"))))
; Servidor\x2Ehome\x2Eedonkey\x2Ecom
(assert (not (str.in_re X (str.to_re "Servidor.\u{13}home.edonkey.com\u{0a}"))))
; httphostHost\u{3a}Agent\u{22}
(assert (not (str.in_re X (str.to_re "httphostHost:Agent\u{22}\u{0a}"))))
; User-Agent\u{3a}\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (str.to_re "User-Agent:/newsurfer4/\u{0a}"))))
(check-sat)
