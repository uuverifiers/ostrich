(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /u=[\dA-Fa-f]{8}/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/u=") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (str.to_re "/smiU\u{0a}")))))
; /filename=[^\n]*\u{2e}pfm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pfm/i\u{0a}")))))
; Word\w+My\s+\u{22}TheZC-BridgeUser-Agent\x3AserverUSER-Attached
(assert (not (str.in_re X (re.++ (str.to_re "Word") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "My") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}TheZC-BridgeUser-Agent:serverUSER-Attached\u{0a}")))))
; ^([0]?[1-9]|[1][0-2]|[2][0-3]):([0-5][0-9]|[1-9])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.union (re.++ (re.range "0" "5") (re.range "0" "9")) (re.range "1" "9")) (str.to_re "\u{0a}")))))
(check-sat)
