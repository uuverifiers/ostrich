(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <script[^>]*>[\w|\t|\r|\W]*</script>
(assert (not (str.in_re X (re.++ (str.to_re "<script") (re.* (re.comp (str.to_re ">"))) (str.to_re ">") (re.* (re.union (str.to_re "|") (str.to_re "\u{09}") (str.to_re "\u{0d}") (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "</script>\u{0a}")))))
; ^\d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\x3A\s+Server\u{00}User-Agent\u{3a}toolsbar\x2Ekuaiso\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Server\u{00}User-Agent:toolsbar.kuaiso.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
