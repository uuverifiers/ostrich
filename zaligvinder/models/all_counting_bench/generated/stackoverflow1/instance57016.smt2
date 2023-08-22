;test regex ([a-zA-Z0-9.]+)\\s*(?:at|@|\(at\))\\s*(\\w+)\\s*(?:do?t|\\.)\\s*(\\w+{1,3})
(declare-const X String)
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.union (re.range "A" "Z") (re.union (re.range "0" "9") (str.to_re "."))))) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (re.union (re.union (re.++ (str.to_re "a") (str.to_re "t")) (str.to_re "@")) (re.++ (str.to_re "(") (re.++ (str.to_re "a") (re.++ (str.to_re "t") (str.to_re ")"))))) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (re.++ (str.to_re "\\") (re.+ (str.to_re "w"))) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (re.union (re.++ (str.to_re "d") (re.++ (re.opt (str.to_re "o")) (str.to_re "t"))) (re.++ (str.to_re "\\") (re.diff re.allchar (str.to_re "\n")))) (re.++ (str.to_re "\\") (re.++ (re.* (str.to_re "s")) (re.++ (str.to_re "\\") ((_ re.loop 1 3) (re.+ (str.to_re "w"))))))))))))))))))
; sanitize danger characters:  < > ' " &
(assert (not (str.in_re X (re.++ re.all (re.union (str.to_re "\u{3c}") (str.to_re "\u{3e}") (str.to_re "\u{27}") (str.to_re "\u{22}") (str.to_re "\u{26}")) re.all))))
(assert (< 10 (str.len X)))
(check-sat)
(get-model)