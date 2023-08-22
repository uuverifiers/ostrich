(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}msi([\?\u{5c}\u{2f}]|$)/miU
(assert (not (str.in_re X (re.++ (str.to_re "/.msi") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/miU\u{0a}")))))
; ^[B|K|T|P][A-Z][0-9]{4}$
(assert (str.in_re X (re.++ (re.union (str.to_re "B") (str.to_re "|") (str.to_re "K") (str.to_re "T") (str.to_re "P")) (re.range "A" "Z") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; User-Agent\x3A[^\n\r]*quick\x2Eqsrch\x2Ecom.*www\.searchinweb\.com
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "quick.qsrch.com") (re.* re.allchar) (str.to_re "www.searchinweb.com\u{0a}")))))
; /filename=[^\n]*\u{2e}vap/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vap/i\u{0a}")))))
; vbwwwc\.goclick\.compassword\x3B0\x3BIncorrect
(assert (not (str.in_re X (str.to_re "vbwwwc.goclick.compassword;0;Incorrect\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
