(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <a[a-zA-Z0-9 ="'.:;?]*(name=){1}[a-zA-Z0-9 ="'.:;?]*\s*((/>)|(>[a-zA-Z0-9 ="'<>.:;?]*</a>))
(assert (str.in_re X (re.++ (str.to_re "<a") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "=") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ".") (str.to_re ":") (str.to_re ";") (str.to_re "?"))) ((_ re.loop 1 1) (str.to_re "name=")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "=") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ".") (str.to_re ":") (str.to_re ";") (str.to_re "?"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "/>") (re.++ (str.to_re ">") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "=") (str.to_re "\u{22}") (str.to_re "'") (str.to_re "<") (str.to_re ">") (str.to_re ".") (str.to_re ":") (str.to_re ";") (str.to_re "?"))) (str.to_re "</a>"))) (str.to_re "\u{0a}"))))
; ^([A-Z0-9?.+-])+([,]([A-Z0-9?.+-])+)*$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "?") (str.to_re ".") (str.to_re "+") (str.to_re "-"))) (re.* (re.++ (str.to_re ",") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "?") (str.to_re ".") (str.to_re "+") (str.to_re "-"))))) (str.to_re "\u{0a}"))))
(check-sat)
