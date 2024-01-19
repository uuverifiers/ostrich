(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/ABs[A-Za-z0-9]+$/U
(assert (not (str.in_re X (re.++ (str.to_re "//ABs") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; ^((\D*[a-z]\D*[A-Z]\D*)|(\D*[A-Z]\D*[a-z]\D*)|(\D*\W\D*[a-z])|(\D*\W\D*[A-Z])|(\D*[a-z]\D*\W)|(\D*[A-Z]\D*\W))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.* (re.comp (re.range "0" "9"))) (re.range "a" "z") (re.* (re.comp (re.range "0" "9"))) (re.range "A" "Z") (re.* (re.comp (re.range "0" "9")))) (re.++ (re.* (re.comp (re.range "0" "9"))) (re.range "A" "Z") (re.* (re.comp (re.range "0" "9"))) (re.range "a" "z") (re.* (re.comp (re.range "0" "9")))) (re.++ (re.* (re.comp (re.range "0" "9"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.comp (re.range "0" "9"))) (re.range "a" "z")) (re.++ (re.* (re.comp (re.range "0" "9"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.comp (re.range "0" "9"))) (re.range "A" "Z")) (re.++ (re.* (re.comp (re.range "0" "9"))) (re.range "a" "z") (re.* (re.comp (re.range "0" "9"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.++ (re.* (re.comp (re.range "0" "9"))) (re.range "A" "Z") (re.* (re.comp (re.range "0" "9"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{0a}"))))
; \x2FrssScaneradfsgecoiwnf\x7D\x7BTrojan\x3AlogsHost\u{3a}
(assert (str.in_re X (str.to_re "/rssScaneradfsgecoiwnf\u{1b}}{Trojan:logsHost:\u{0a}")))
; ^[D-d][K-k]( |-)[1-9]{1}[0-9]{3}$
(assert (not (str.in_re X (re.++ (re.range "D" "d") (re.range "K" "k") (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; trustyfiles\x2EcomBlade\u{23}\u{23}\u{23}\u{23}\.smx\?
(assert (str.in_re X (str.to_re "trustyfiles.comBlade####.smx?\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
