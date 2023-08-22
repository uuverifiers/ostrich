(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\d{3}\-\d{2}\-\d{4})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))))
; /\u{2e}tga([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.tga") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; Host\u{3a}\dgpstool\u{2e}globaladserver\u{2e}comdesksearch\.dropspam\.com
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "gpstool.globaladserver.comdesksearch.dropspam.com\u{0a}"))))
; /^User-Agent\x3A[^\r\n]*beagle_beagle/smiH
(assert (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "beagle_beagle/smiH\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
