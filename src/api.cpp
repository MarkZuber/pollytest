#include "interface/api.hpp"
#include <memory>

struct ApiImpl: djinni_cmake::Api {
    bool doSomething() {
        return true;
    }
};


std::shared_ptr<djinni_cmake::Api> djinni_cmake::Api::get() {
    return std::make_shared<ApiImpl>();
}
