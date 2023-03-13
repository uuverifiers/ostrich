(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(smtp)\.([\w\-]+)\.[\w\-]{2,3}$
(assert (not (str.in_re X (re.++ (str.to_re "smtp.") (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; ^http://([a-zA-Z0-9_\-]+)([\.][a-zA-Z0-9_\-]+)+([/][a-zA-Z0-9\~\(\)_\-]*)+([\.][a-zA-Z0-9\(\)_\-]+)*$
(assert (str.in_re X (re.++ (str.to_re "http://") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.+ (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))))) (re.+ (re.++ (str.to_re "/") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "~") (str.to_re "(") (str.to_re ")") (str.to_re "_") (str.to_re "-"))))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "(") (str.to_re ")") (str.to_re "_") (str.to_re "-"))))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}ets/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ets/i\u{0a}")))))
; ApofisAgentFunWebProductsUser-Agent\x3A
(assert (str.in_re X (str.to_re "ApofisAgentFunWebProductsUser-Agent:\u{0a}")))
; fhfksjzsfu\u{2f}ahm\.uqs\s+Host\u{3a}\swww\.fast-finder\.com\sStarted\!$3
(assert (not (str.in_re X (re.++ (str.to_re "fhfksjzsfu/ahm.uqs") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.fast-finder.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Started!3\u{0a}")))))
(check-sat)
