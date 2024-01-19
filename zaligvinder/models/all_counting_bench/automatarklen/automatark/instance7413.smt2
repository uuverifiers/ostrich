(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([3]{1}[0-1]{1}|[1-1]?[0-9]{1})-([0-1]?[0-2]{1}|[0-9]{1})-[0-9]{4}([\s]+([2]{1}[0-3]{1}|[0-1]?[0-9]{1})[:]{1}([0-5]?[0-9]{1})([:]{1}([0-5]?[0-9]{1}))?)?$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (str.to_re "3")) ((_ re.loop 1 1) (re.range "0" "1"))) (re.++ (re.opt (re.range "1" "1")) ((_ re.loop 1 1) (re.range "0" "9")))) (str.to_re "-") (re.union (re.++ (re.opt (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "2"))) ((_ re.loop 1 1) (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ ((_ re.loop 1 1) (str.to_re "2")) ((_ re.loop 1 1) (re.range "0" "3"))) (re.++ (re.opt (re.range "0" "1")) ((_ re.loop 1 1) (re.range "0" "9")))) ((_ re.loop 1 1) (str.to_re ":")) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re ":")) (re.opt (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.opt (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}ram/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ram/i\u{0a}"))))
; eveocczmthmmq\u{2f}omzl\s+zmnjgmomgbdz\u{2f}zzmw\.gzt
(assert (str.in_re X (re.++ (str.to_re "eveocczmthmmq/omzl") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "zmnjgmomgbdz/zzmw.gzt\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
