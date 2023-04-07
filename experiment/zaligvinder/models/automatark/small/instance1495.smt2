(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; alert\d+an.*Spyiz=e2give\.comrichfind\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "alert") (re.+ (re.range "0" "9")) (str.to_re "an") (re.* re.allchar) (str.to_re "Spyiz=e2give.comrichfind.com\u{0a}")))))
; (\[[Ii][Mm][Gg]\])(\S+?)(\[\/[Ii][Mm][Gg]\])
(assert (str.in_re X (re.++ (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}[") (re.union (str.to_re "I") (str.to_re "i")) (re.union (str.to_re "M") (str.to_re "m")) (re.union (str.to_re "G") (str.to_re "g")) (str.to_re "][/") (re.union (str.to_re "I") (str.to_re "i")) (re.union (str.to_re "M") (str.to_re "m")) (re.union (str.to_re "G") (str.to_re "g")) (str.to_re "]"))))
; (http):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+(\\.[\\w\\-_]+)(\\/)([\\w\\-\\.,@?^=%&:/~\\+#]*[\\w\\-\\@?^=%&/~\\+#]+)(\\/)((\\d{8}-)|(\\d{9}-)|(\\d{10}-)|(\\d{11}-))+([\\w\\-\\.,@?^=%&:/~\\+#]*[\\w\\-\\@?+html^])?
(assert (not (str.in_re X (re.++ (str.to_re "http:\u{5c}/\u{5c}/") (re.+ (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "_"))) (re.+ (re.++ (str.to_re "\u{5c}") re.allchar (re.+ (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "_"))))) (str.to_re "\u{5c}/\u{5c}/") (re.+ (re.union (re.++ (str.to_re "\u{5c}") ((_ re.loop 8 8) (str.to_re "d")) (str.to_re "-")) (re.++ (str.to_re "\u{5c}") ((_ re.loop 9 9) (str.to_re "d")) (str.to_re "-")) (re.++ (str.to_re "\u{5c}") ((_ re.loop 10 10) (str.to_re "d")) (str.to_re "-")) (re.++ (str.to_re "\u{5c}") ((_ re.loop 11 11) (str.to_re "d")) (str.to_re "-")))) (re.opt (re.++ (re.* (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "\u{5c}") (str.to_re ".") (str.to_re ",") (str.to_re "@") (str.to_re "?") (str.to_re "^") (str.to_re "=") (str.to_re "%") (str.to_re "&") (str.to_re ":") (str.to_re "/") (str.to_re "~") (str.to_re "+") (str.to_re "#"))) (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "\u{5c}") (str.to_re "@") (str.to_re "?") (str.to_re "+") (str.to_re "h") (str.to_re "t") (str.to_re "m") (str.to_re "l") (str.to_re "^")))) (str.to_re "\u{0a}\u{5c}") re.allchar (re.+ (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "_"))) (re.* (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "\u{5c}") (str.to_re ".") (str.to_re ",") (str.to_re "@") (str.to_re "?") (str.to_re "^") (str.to_re "=") (str.to_re "%") (str.to_re "&") (str.to_re ":") (str.to_re "/") (str.to_re "~") (str.to_re "+") (str.to_re "#"))) (re.+ (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "\u{5c}") (str.to_re "@") (str.to_re "?") (str.to_re "^") (str.to_re "=") (str.to_re "%") (str.to_re "&") (str.to_re "/") (str.to_re "~") (str.to_re "+") (str.to_re "#")))))))
(check-sat)