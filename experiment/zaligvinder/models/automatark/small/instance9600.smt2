(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; toolbar\.wishbone\.com\s+GET.*toowww\.123mania\.com\x2EphpLibrary
(assert (not (str.in_re X (re.++ (str.to_re "toolbar.wishbone.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "GET") (re.* re.allchar) (str.to_re "toowww.123mania.com.phpLibrary\u{0a}")))))
; \b([0]?[1-9]|[1,2]\d|3[0,1])[-/]([0]?[1-9]|[1][0,1,2])[-/](\d{1,2}|[1][9]\d\d|[2][0]\d\d)\b
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re ",") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "1")))) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "1") (str.to_re "2")))) (re.union (str.to_re "-") (str.to_re "/")) (re.union ((_ re.loop 1 2) (re.range "0" "9")) (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "20") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^\s*\(?((\+0?44)?\)?[ \-]?(\(0\))|0)((20[7,8]{1}\)?[ \-]?[1-9]{1}[0-9]{2}[ \-]?[0-9]{4})|([1-8]{1}[0-9]{3}\)?[ \-]?[1-9]{1}[0-9]{2}[ \-]?[0-9]{3}))\s*$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "(")) (re.union (re.++ (re.opt (re.++ (str.to_re "+") (re.opt (str.to_re "0")) (str.to_re "44"))) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) (str.to_re "(0)")) (str.to_re "0")) (re.union (re.++ (str.to_re "20") ((_ re.loop 1 1) (re.union (str.to_re "7") (str.to_re ",") (str.to_re "8"))) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "8")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
(check-sat)