(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}ani([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.ani") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; AD\s+c\.goclick\.com\w+asdbiz\x2Ebizfrom\u{7c}roogoo\u{7c}Current
(assert (str.in_re X (re.++ (str.to_re "AD") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "c.goclick.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "asdbiz.bizfrom|roogoo|Current\u{0a}"))))
; /^\/[a-f0-9]{8}\.js\?cp\u{3d}/Umi
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".js?cp=/Umi\u{0a}"))))
; (a|A)
(assert (not (str.in_re X (re.++ (re.union (str.to_re "a") (str.to_re "A")) (str.to_re "\u{0a}")))))
; (^13((\ )?\d){4}$)|(^1[38]00((\ )?\d){6}$)|(^(((\(0[23478]\))|(0[23478]))(\ )?)?\d((\ )?\d){7}$)
(assert (not (str.in_re X (re.union (re.++ (str.to_re "13") ((_ re.loop 4 4) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9")))) (re.++ (str.to_re "1") (re.union (str.to_re "3") (str.to_re "8")) (str.to_re "00") ((_ re.loop 6 6) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9")))) (re.++ (str.to_re "\u{0a}") (re.opt (re.++ (re.union (re.++ (str.to_re "(0") (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "7") (str.to_re "8")) (str.to_re ")")) (re.++ (str.to_re "0") (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "7") (str.to_re "8")))) (re.opt (str.to_re " ")))) (re.range "0" "9") ((_ re.loop 7 7) (re.++ (re.opt (str.to_re " ")) (re.range "0" "9"))))))))
(assert (> (str.len X) 10))
(check-sat)
