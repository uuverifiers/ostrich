(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; info\s+wjpropqmlpohj\u{2f}lo\s+resultsmaster\x2Ecom\u{7c}roogoo\u{7c}
(assert (not (str.in_re X (re.++ (str.to_re "info") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "wjpropqmlpohj/lo") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "resultsmaster.com\u{13}|roogoo|\u{0a}")))))
; NavExcel\s+dist\x2Eatlas\x2Dia\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "NavExcel") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "dist.atlas-ia.com\u{0a}")))))
; ^(\$|)([1-9]+\d{0,2}(\,\d{3})*|([1-9]+\d*))(\.\d{2})?$
(assert (str.in_re X (re.++ (str.to_re "$") (re.union (re.++ (re.+ (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; \b([\d\w\.\/\+\-\?\:]*)((ht|f)tp(s|)\:\/\/|[\d\d\d|\d\d]\.[\d\d\d|\d\d]\.|www\.|\.tv|\.ac|\.com|\.edu|\.gov|\.int|\.mil|\.net|\.org|\.biz|\.info|\.name|\.pro|\.museum|\.co)([\d\w\.\/\%\+\-\=\&\?\:\\\"\'\,\|\~\;]*)\b
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "/") (str.to_re "+") (str.to_re "-") (str.to_re "?") (str.to_re ":") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (re.++ (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tps://")) (re.++ (re.union (re.range "0" "9") (str.to_re "|")) (str.to_re ".") (re.union (re.range "0" "9") (str.to_re "|")) (str.to_re ".")) (str.to_re "www.") (str.to_re ".tv") (str.to_re ".ac") (str.to_re ".com") (str.to_re ".edu") (str.to_re ".gov") (str.to_re ".int") (str.to_re ".mil") (str.to_re ".net") (str.to_re ".org") (str.to_re ".biz") (str.to_re ".info") (str.to_re ".name") (str.to_re ".pro") (str.to_re ".museum") (str.to_re ".co")) (re.* (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "/") (str.to_re "%") (str.to_re "+") (str.to_re "-") (str.to_re "=") (str.to_re "&") (str.to_re "?") (str.to_re ":") (str.to_re "\u{5c}") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ",") (str.to_re "|") (str.to_re "~") (str.to_re ";") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; ^([0-7]{3})$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "7")) (str.to_re "\u{0a}")))))
(check-sat)
