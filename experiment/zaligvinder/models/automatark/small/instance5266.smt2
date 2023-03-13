(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]{3}-[0-9]{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}xpm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xpm/i\u{0a}")))))
; ^[0-9]{10}GBR[0-9]{7}[U,M,F]{1}[0-9]{9}$
(assert (not (str.in_re X (re.++ ((_ re.loop 10 10) (re.range "0" "9")) (str.to_re "GBR") ((_ re.loop 7 7) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "U") (str.to_re ",") (str.to_re "M") (str.to_re "F"))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \u{22}reaction\x2Etxt\u{22}User-Agent\x3AnewsSpyAgentsmrtshpr-cs-
(assert (not (str.in_re X (str.to_re "\u{22}reaction.txt\u{22}User-Agent:newsSpyAgentsmrtshpr-cs-\u{13}\u{0a}"))))
(check-sat)
