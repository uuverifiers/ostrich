(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; bar\-navig\x2Eyandex\x2Eru\s+
(assert (str.in_re X (re.++ (str.to_re "bar-navig.yandex.ru") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; Host\x3A.*Toolbar\s+Host\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}")))))
; /^\/[\w-]{48}\.[a-z]{2,8}[0-9]?$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 48 48) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 8) (re.range "a" "z")) (re.opt (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; <script.*/*>|</script>|<[a-zA-Z][^>]*=['"]+javascript:\w+.*['"]+>|<\w+[^>]*\son\w+=.*[ /]*>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.union (re.++ (str.to_re "script") (re.* re.allchar) (re.* (str.to_re "/")) (str.to_re ">")) (str.to_re "/script>") (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.comp (str.to_re ">"))) (str.to_re "=") (re.+ (re.union (str.to_re "'") (str.to_re "\u{22}"))) (str.to_re "javascript:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar) (re.+ (re.union (str.to_re "'") (str.to_re "\u{22}"))) (str.to_re ">")) (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.comp (str.to_re ">"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "on") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "=") (re.* re.allchar) (re.* (re.union (str.to_re " ") (str.to_re "/"))) (str.to_re ">\u{0a}")))))))
(check-sat)
