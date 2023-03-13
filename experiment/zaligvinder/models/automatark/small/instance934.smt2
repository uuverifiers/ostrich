(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /("(\\["\\]|[^"])*("|$)|\S)+/g
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.union (re.++ (str.to_re "\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (re.comp (str.to_re "\u{22}")))) (str.to_re "\u{22}")) (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (str.to_re "/g\u{0a}"))))
; Onetrustyfiles\x2EcomOverSpyzopabora\x2Einfo
(assert (str.in_re X (str.to_re "Onetrustyfiles.comOverSpyzopabora.info\u{0a}")))
; ^(\w+([_.]{1}\w+)*@\w+([_.]{1}\w+)*\.[A-Za-z]{2,3}[;]?)*$
(assert (str.in_re X (re.++ (re.* (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ ((_ re.loop 1 1) (re.union (str.to_re "_") (str.to_re "."))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ ((_ re.loop 1 1) (re.union (str.to_re "_") (str.to_re "."))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re ";")))) (str.to_re "\u{0a}"))))
; \x2Fezsb\s+hirmvtg\u{2f}ggqh\.kqh\dRemotetoolsbar\x2Ekuaiso\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "/ezsb") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "hirmvtg/ggqh.kqh\u{1b}") (re.range "0" "9") (str.to_re "Remotetoolsbar.kuaiso.com\u{0a}"))))
; ^(\+971[\s]{0,1}[\-]{0,1}[\s]{0,1}|[\s]{0,1}0)(5[056]{1})[\s]{0,1}[\-]{0,1}[\s]{0,1}[1-9]{1}[0-9]{6}$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "+971") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "0"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}5") ((_ re.loop 1 1) (re.union (str.to_re "0") (str.to_re "5") (str.to_re "6"))))))
(check-sat)
