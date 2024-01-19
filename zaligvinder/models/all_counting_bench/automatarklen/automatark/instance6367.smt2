(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\$\s*[\d,]+\.\d{2})\b
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}$") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "0" "9") (str.to_re ","))) (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))
; [a-zA-Z]*( [a-zA-Z]*)?
(assert (str.in_re X (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (str.to_re " ") (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
; Readydoarauzeraqf\u{2f}vvv\.ulPALTALKHello\x2EMyAgentUser-Agent\x3AIP-FILEUser-Agent\x3AUser-Agent\x3A
(assert (str.in_re X (str.to_re "Readydoarauzeraqf/vvv.ulPALTALKHello.MyAgentUser-Agent:IP-FILEUser-Agent:User-Agent:\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
