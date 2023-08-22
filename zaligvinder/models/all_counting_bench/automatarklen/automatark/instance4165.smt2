(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((\d|([a-f]|[A-F])){2}:){5}(\d|([a-f]|[A-F])){2}
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re ":"))) ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}"))))
; /\.makeMeasurement\s*\u{28}[^\u{3b}]+?Array/i
(assert (str.in_re X (re.++ (str.to_re "/.makeMeasurement") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.+ (re.comp (str.to_re ";"))) (str.to_re "Array/i\u{0a}"))))
; (((0[1-9]|(1|2)[0-9]|3[0-1])\/(0(1|3|5|7|8)|1(0|2)))|((0[1-9]|(1|2)[0-9]|30)\/(0(4|6|9)|11))|((0[1-9]|(1|2)[0-9])\/02))\/[0-9]{4}
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2"))))) (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (str.to_re "30")) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "4") (str.to_re "6") (str.to_re "9"))) (str.to_re "11"))) (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9"))) (str.to_re "/02"))) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2e}fli([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.fli") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; \<script[^>]*>[\w|\t|\r\|\W]*?</script>
(assert (not (str.in_re X (re.++ (str.to_re "<script") (re.* (re.comp (str.to_re ">"))) (str.to_re ">") (re.* (re.union (str.to_re "|") (str.to_re "\u{09}") (str.to_re "\u{0d}") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "</script>\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
