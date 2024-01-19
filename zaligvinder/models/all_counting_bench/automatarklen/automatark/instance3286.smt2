(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z]+[a-zA-Z]*)(\s|\-)?([A-Z]+[a-zA-Z]*)?(\s|\-)?([A-Z]+[a-zA-Z]*)?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.+ (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.+ (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}") (re.+ (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))))))
; XP\d+Acme\s+\x2Fcbn\x2Fnode=Host\x3A\x3Fsearch\x3DversionContact
(assert (not (str.in_re X (re.++ (str.to_re "XP") (re.+ (re.range "0" "9")) (str.to_re "Acme") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cbn/node=Host:?search=versionContact\u{0a}")))))
; (^N/A$)|(^[-]?(\d+)(\.\d{0,3})?$)|(^[-]?(\d{1,3},(\d{3},)*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{1,3})?)$)
(assert (not (str.in_re X (re.union (str.to_re "N/A") (re.++ (re.opt (str.to_re "-")) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 3) (re.range "0" "9"))))) (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))))))))))
(assert (> (str.len X) 10))
(check-sat)
