(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Readydoarauzeraqf\u{2f}vvv\.ulPALTALKHello\x2EMyAgentUser-Agent\x3AIP-FILEUser-Agent\x3AUser-Agent\x3A
(assert (str.in_re X (str.to_re "Readydoarauzeraqf/vvv.ulPALTALKHello.MyAgentUser-Agent:IP-FILEUser-Agent:User-Agent:\u{0a}")))
; ^[\d]{5}[-\s]{1}[\d]{3}[-\s]{1}[\d]{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2e}gni([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.gni") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; Yeah\!Host\x3AEnTrYwww\x2EZSearchResults\x2Ecom
(assert (not (str.in_re X (str.to_re "Yeah!Host:EnTrYwww.ZSearchResults.com\u{13}\u{0a}"))))
; /filename=[^\n]*\u{2e}fon/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fon/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
