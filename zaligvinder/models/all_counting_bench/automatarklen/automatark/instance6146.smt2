(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\+)?(\()?(\d+){1,4}(\))?(\s)?(-)?(\d+){1,3}(\s)?(-)?(\d+){1,4}(\s)?(-)?(\d+){1,4}(\s)?(-)?(\d+){1,4}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.opt (str.to_re "(")) ((_ re.loop 1 4) (re.+ (re.range "0" "9"))) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.+ (re.range "0" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) ((_ re.loop 1 4) (re.+ (re.range "0" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) ((_ re.loop 1 4) (re.+ (re.range "0" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) ((_ re.loop 1 4) (re.+ (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; Host\x3A\d+zmnjgmomgbdz\u{2f}zzmw\.gzt%3ftoolbar\x2Ei-lookup\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "zmnjgmomgbdz/zzmw.gzt%3ftoolbar.i-lookup.com\u{0a}")))))
; preg_match_all("/([\(\+])?([0-9]{1,3}([\s])?)?([\+|\(|\-|\)|\s])?([0-9]{2,4})([\-|\)|\.|\s]([\s])?)?([0-9]{2,4})?([\.|\-|\s])?([0-9]{4,8})/",$string, $phones);
(assert (str.in_re X (re.++ (str.to_re "preg_match_all;\u{0a}\u{22}/") (re.opt (re.union (str.to_re "(") (str.to_re "+"))) (re.opt (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.opt (re.union (str.to_re "+") (str.to_re "|") (str.to_re "(") (str.to_re "-") (str.to_re ")") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 4) (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re "-") (str.to_re "|") (str.to_re ")") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.opt ((_ re.loop 2 4) (re.range "0" "9"))) (re.opt (re.union (str.to_re ".") (str.to_re "|") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 8) (re.range "0" "9")) (str.to_re "/\u{22},string, phones"))))
; /("(\\["\\]|[^"])*("|$)|\S)+/g
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.union (re.++ (str.to_re "\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{22}")) (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "/g\u{0a}"))))
; /\/[a-z]{2}\/testcon.php$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "/testcon") re.allchar (str.to_re "php/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)