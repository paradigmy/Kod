import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class StreamAPI {

    public static List<String> preber(List<String> lst, String word) {
        List<String> result = new ArrayList<>();
        for (String elem : lst)
            if (elem.contains(word))
                result.add(elem.toUpperCase());
        return result;
    }
    public static List<String> preberStreamAPI(List<String> lst, String word) {
        return lst
                .stream()
                .filter(elem -> elem.contains(word))
                .map(String::toUpperCase)
                .collect(Collectors.toList());
    }
    public static List<String> preberStreamAPIParallel(List<String> lst, String word) {
        return lst
                .parallelStream()
                .filter(elem -> elem.contains(word))
                .map(String::toUpperCase)
                .collect(Collectors.toList());
    }

    public static void main(String[] args) {
        List<String> test = List.of( "Peter", "Jano", "Jana");
        System.out.println(preber(test, "Jan"));
        System.out.println(preberStreamAPI(test, "Jan"));
        System.out.println(preberStreamAPIParallel(test, "Jan"));
    }

}
