(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b(((J(ANUARY|UNE|ULY))|FEBRUARY|MARCH|(A(PRIL|UGUST))|MAY|(SEPT|NOV|DEC)EMBER|OCTOBER))\s*(0?[1-9]|1[0-9]|2[0-9]|3[0-1])\s*(\,)\s*(0[0-9])\b
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "J") (re.union (str.to_re "ANUARY") (str.to_re "UNE") (str.to_re "ULY"))) (str.to_re "FEBRUARY") (str.to_re "MARCH") (re.++ (str.to_re "A") (re.union (str.to_re "PRIL") (str.to_re "UGUST"))) (str.to_re "MAY") (re.++ (re.union (str.to_re "SEPT") (str.to_re "NOV") (str.to_re "DEC")) (str.to_re "EMBER")) (str.to_re "OCTOBER")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ",") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}0") (re.range "0" "9")))))
; Fen\u{ea}treEye\x2Fdss\x2Fcc\.2_0_0\.TROJAN-
(assert (str.in_re X (str.to_re "Fen\u{ea}treEye/dss/cc.2_0_0.TROJAN-\u{0a}")))
; /^\s*?EHLO\s+\d[\d\u{2e}]{500}/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "EHLO") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") ((_ re.loop 500 500) (re.union (re.range "0" "9") (str.to_re "."))) (str.to_re "/\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
