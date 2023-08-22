(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}addin/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".addin/i\u{0a}")))))
; ^-?\d{1,3}\.(\d{3}\.)*\d{3},\d\d$|^-?\d{1,3},\d\d$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.range "0" "9") (re.range "0" "9") (str.to_re "\u{0a}")))))
; ^
(assert (str.in_re X (str.to_re "\u{0a}")))
; This\s+\x7D\x7BPassword\x3A\d+
(assert (not (str.in_re X (re.++ (str.to_re "This") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Password:\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; FCTB1\stoolbar\.anwb\.nlrichfind\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "FCTB1") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "toolbar.anwb.nlrichfind.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
