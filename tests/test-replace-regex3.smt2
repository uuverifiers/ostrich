
(declare-fun a () String)
(declare-fun b () String)

(assert (= b (str.replace_re a (re.* re.allchar) "")))
(assert (distinct b ""))

(check-sat)
