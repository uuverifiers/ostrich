(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([+(]?\d{0,2}[)]?)([-/.\s]?\d+)+
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "/") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re "+") (str.to_re "("))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (str.to_re ")"))))))
; <script.*/*>|</script>|<[a-zA-Z][^>]*=['"]+javascript:\w+.*['"]+>|<\w+[^>]*\son\w+=.*[ /]*>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.union (re.++ (str.to_re "script") (re.* re.allchar) (re.* (str.to_re "/")) (str.to_re ">")) (str.to_re "/script>") (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.comp (str.to_re ">"))) (str.to_re "=") (re.+ (re.union (str.to_re "'") (str.to_re "\u{22}"))) (str.to_re "javascript:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar) (re.+ (re.union (str.to_re "'") (str.to_re "\u{22}"))) (str.to_re ">")) (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.comp (str.to_re ">"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "on") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "=") (re.* re.allchar) (re.* (re.union (str.to_re " ") (str.to_re "/"))) (str.to_re ">\u{0a}")))))))
; ^(\+86)(13[0-9]|145|147|15[0-3,5-9]|18[0,2,5-9])(\d{8})$
(assert (str.in_re X (re.++ (str.to_re "+86") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}1") (re.union (re.++ (str.to_re "3") (re.range "0" "9")) (str.to_re "45") (str.to_re "47") (re.++ (str.to_re "5") (re.union (re.range "0" "3") (str.to_re ",") (re.range "5" "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "0") (str.to_re ",") (str.to_re "2") (re.range "5" "9")))))))
; A-311[^\n\r]*Attached\sHost\x3AWordmyway\.comhoroscope2
(assert (not (str.in_re X (re.++ (str.to_re "A-311") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Attached") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:Wordmyway.comhoroscope2\u{0a}")))))
; ^([987]{1})(\d{1})(\d{8})
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "9") (str.to_re "8") (str.to_re "7"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
