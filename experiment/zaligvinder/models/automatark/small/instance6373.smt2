(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}pfb([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pfb") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^[B|K|T|P][A-Z][0-9]{4}$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "B") (str.to_re "|") (str.to_re "K") (str.to_re "T") (str.to_re "P")) (re.range "A" "Z") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; IPUSER-Host\x3AUser-Agent\x3A\x2Fsearchfast\x2F
(assert (str.in_re X (str.to_re "IPUSER-Host:User-Agent:/searchfast/\u{0a}")))
(check-sat)
