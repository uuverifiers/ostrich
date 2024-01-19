(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^13((\ )?\d){4}$)|(^1[38]00((\ )?\d){6}$)|(^(((\(0[23478]\))|(0[23478]))(\ )?)?\d((\ )?\d){7}$)
(assert (str.in_re X (re.union (re.++ (str.to_re "13") ((_ re.loop 4 4) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9")))) (re.++ (str.to_re "1") (re.union (str.to_re "3") (str.to_re "8")) (str.to_re "00") ((_ re.loop 6 6) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9")))) (re.++ (str.to_re "\u{0a}") (re.opt (re.++ (re.union (re.++ (str.to_re "(0") (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "7") (str.to_re "8")) (str.to_re ")")) (re.++ (str.to_re "0") (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "7") (str.to_re "8")))) (re.opt (str.to_re " ")))) (re.range "0" "9") ((_ re.loop 7 7) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9")))))))
; Hours\w+User-Agent\x3AChildWebGuardian
(assert (not (str.in_re X (re.++ (str.to_re "Hours") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "User-Agent:ChildWebGuardian\u{0a}")))))
; /filename=[^\n]*\u{2e}smil/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".smil/i\u{0a}")))))
; ^<\s*(td|TD)\s*(\w|\W)*\s*>(\w|\W)*</(td|TD)>$
(assert (str.in_re X (re.++ (str.to_re "<") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "td") (str.to_re "TD")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ">") (re.* (re.union (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "</") (re.union (str.to_re "td") (str.to_re "TD")) (str.to_re ">\u{0a}"))))
; ^([0-9a-fA-F]{1,2})(\s[0-9a-fA-F]{1,2})*$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.* (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
