(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A3AHelpAgent\x3AHost\x3AsearchresltHost\x3Anotification
(assert (not (str.in_re X (str.to_re "User-Agent:3AHelpAgent:Host:searchresltHost:notification\u{13}\u{0a}"))))
; ^([a-z|A-Z]{1}[0-9]{3})[-]([0-9]{3})[-]([0-9]{2})[-]([0-9]{3})[-]([0-9]{1})
(assert (str.in_re X (re.++ (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (re.range "a" "z") (str.to_re "|") (re.range "A" "Z"))) ((_ re.loop 3 3) (re.range "0" "9")))))
; /^POST\u{20}\u{2f}g[ao]lfstream\u{26}/
(assert (str.in_re X (re.++ (str.to_re "/POST /g") (re.union (str.to_re "a") (str.to_re "o")) (str.to_re "lfstream&/\u{0a}"))))
(check-sat)
